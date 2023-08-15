//
//  LangWidget.swift
//  LangWidget
//
//  Created by liu lang on 2023/8/14.
//

import Combine
import SwiftUI
import WidgetKit

private struct Provider: TimelineProvider {

    private static var cancellables = Set<AnyCancellable>()
    // MARK: Cache
    private static let cache = NSCache<NSURL, NSData>()

    private func getImageFromCache(url: URL) -> Data? {
        guard let data = Self.cache.object(forKey: url as NSURL) else {
            return nil
        }
        return data as Data
    }

    private func saveImageToCache(url: URL, data: Data) {
        Self.cache.setObject(data as NSData, forKey: url as NSURL)
    }

    // MARK: TimelineProvider

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        loadImageData { imageData, isCached, description in
            let currentDate = Date()
            let nextDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
            let entries = [
                SimpleEntry(date: currentDate, imageData: imageData, isCached: isCached, description: description),
                SimpleEntry(date: nextDate, imageData: imageData, isCached: isCached, description: description)
            ]
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    // Function to fetch JSON synchronously and get a random link
    func fetchRandomLinkSync(from url: URL) -> String? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
            return nil
        }
        
        guard !response.list.isEmpty else {
            return nil
        }
        
        // Randomize the list field
        let randomizedList = response.list.shuffled()
        
        guard let links = randomizedList.first?.arr.link else {
            return nil
        }
        
        // Generate a random index
        let randomIndex = Int.random(in: 0..<links.count)
        
        // Get the random link
        let randomLink = links[randomIndex]
        
        return randomLink
    }
    
    private static let metaUrlString = "https://raw.githubusercontent.com/LangInteger/LangInteger.github.io/master/photos/data.json"
    private static let pictureBaseUrl = "https://raw.githubusercontent.com/LangInteger/blog_photos/main/min_photos/"
    private func loadImageData(completion: @escaping (Data?, Bool, String) -> Void) {
        guard let metaUrl = URL(string: Self.metaUrlString) else {
            completion(nil, false, "fail fetch from meta url")
            return
        }
        
        guard let randomLink = fetchRandomLinkSync(from: metaUrl) else {
            completion(nil, false, "fail parse result of meta url")
            return
        }
        
        let pictureUrl = Self.pictureBaseUrl + randomLink
        
        guard let encodedPictureUrl = pictureUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedPictureUrl) else {
            completion(nil, false, "illegal random link " + pictureUrl)
            return
        }
        
        
        if let imageData = getImageFromCache(url: url) {
            completion(imageData, true, "load from cache")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink { _ in}
                  receiveValue: {
                    Self.cache.setObject($0 as NSData, forKey: url as NSURL)
                    completion($0, false, "load from cloud")
            }
            .store(in: &Self.cancellables)
    }
}

// Structure to represent the JSON
private struct Response: Codable {
    struct ListEntry: Codable {
        struct ArrEntry: Codable {
            let link: [String]
        }
        let arr: ArrEntry
    }
    let list: [ListEntry]
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    var imageData: Data?
    var isCached = false
    var description = ""
}

private struct URLCachedImageWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        if let data = entry.imageData {
            URLImageView(data: data)
                .aspectRatio(contentMode: .fill)
        }
        Text("\(entry.description)")
    }
}

struct URLCachedImageWidget: Widget {
    private let kind: String = "urlCachedImageWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            URLCachedImageWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("URLCachedImage Widget")
        .description("A Widget that displays an Image downloaded from an external URL and caches it.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
