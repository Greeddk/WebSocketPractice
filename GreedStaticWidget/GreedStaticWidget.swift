//
//  GreedStaticWidget.swift
//  GreedStaticWidget
//
//  Created by Greed on 5/13/24.
//

import WidgetKit
import SwiftUI
//Provider: 위젯 디스플레이 업데이트 시기를 위젯킷에게 알려주기 위한 용도
struct Provider: TimelineProvider {
    //위젯 최초 렌더링
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }
    //위젯 갤러리 미리보기 화면
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }
    //위젯 상태 변경 시점
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }
        //타임라인 마지막 날짜가 지난 뒤, 새로운 타임라인을 위젯킷이 요청할 수 있도록 설정
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date //위젯이 다시 그려질 시간에 대한 정보
    let emoji: String
    //relevance: 스마트 스택, score가 높은 위젯이 스택의 최상단으로 올라옴
}

struct GreedStaticWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(UserDefaults.groupShared.string(forKey: "KoreanName") ?? "데이터 없음")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.emoji)
        }
    }
}

struct GreedStaticWidget: Widget {
    let kind: String = "GreedStaticWidget" //identifier 같은 것

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                GreedStaticWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                GreedStaticWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("나의 첫 위젯")
        .description("이러쿵 저러쿵")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    GreedStaticWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
