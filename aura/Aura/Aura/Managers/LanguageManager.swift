//
//  LanguageManager.swift
//  Aura
//
//  Created by Ezgi Özkan on 15.01.2026.
//

import SwiftUI
import Combine

final class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @AppStorage("appLanguageCode") private var appLanguageCode: String = ""
    @AppStorage("appLanguageUserSelected") private var appLanguageUserSelected: Bool = false

    struct LanguageItem: Identifiable {
        let code: String
        let name: String
        var id: String { code }
    }

    private init() {}

    var effectiveLanguageCode: String {
        appLanguageCode.isEmpty ? "en" : appLanguageCode
    }

    var effectiveLanguageName: String {
        fixedLanguages.first(where: { $0.code == effectiveLanguageCode })?.name
        ?? Locale.current.localizedString(forLanguageCode: effectiveLanguageCode)
        ?? effectiveLanguageCode.uppercased()
    }

    var userSelected: Bool {
        appLanguageUserSelected
    }

    func syncWithDeviceIfNeeded() {
        if !appLanguageUserSelected {
            appLanguageCode = "en"
        }
    }

    func setAutomatic() {
        appLanguageUserSelected = false
        appLanguageCode = "en"
        objectWillChange.send()
    }

    func setLanguage(code: String) {
        appLanguageUserSelected = true
        appLanguageCode = code
        objectWillChange.send()
    }

    private var fixedLanguages: [LanguageItem] {
        [
            .init(code: "ar", name: "Arabic"),
            .init(code: "bn", name: "Bengali"),
            .init(code: "bg", name: "Bulgarian"),
            .init(code: "zh", name: "Chinese"),
            .init(code: "hr", name: "Croatian"),
            .init(code: "cs", name: "Czech"),
            .init(code: "da", name: "Danish"),
            .init(code: "nl", name: "Dutch"),
            .init(code: "en", name: "English"),
            .init(code: "fi", name: "Finnish"),
            .init(code: "fr", name: "French"),
            .init(code: "de", name: "German"),
            .init(code: "el", name: "Greece"),
            .init(code: "he", name: "Hebrew"),
            .init(code: "hi", name: "Hindi"),
            .init(code: "hu", name: "Hungarian"),
            .init(code: "id", name: "Indonesian"),
            .init(code: "it", name: "Italian"),
            .init(code: "ja", name: "Japanese"),
            .init(code: "ko", name: "Korean"),
            .init(code: "lv", name: "Latvian"),
            .init(code: "lt", name: "Lithuanian"),
            .init(code: "no", name: "Norwegian"),
            .init(code: "pl", name: "Polish"),
            .init(code: "pt", name: "Portugese"),
            .init(code: "ro", name: "Romanian"),
            .init(code: "ru", name: "Russian"),
            .init(code: "sr", name: "Serbian"),
            .init(code: "sk", name: "Slovak"),
            .init(code: "sl", name: "Slovene"),
            .init(code: "es", name: "Spanish"),
            .init(code: "sv", name: "Swedish"),
            .init(code: "th", name: "Thai"),
            .init(code: "tr", name: "Turkish"),
            .init(code: "uk", name: "Ukrainian"),
            .init(code: "vi", name: "Vietnamese")
        ]
    }

    func allLanguages() -> [LanguageItem] {
        fixedLanguages
    }

    func filteredLanguages(query: String) -> [LanguageItem] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return fixedLanguages }
        return fixedLanguages.filter {
            $0.name.localizedCaseInsensitiveContains(q) || $0.code.localizedCaseInsensitiveContains(q)
        }
    }

    func flagEmoji(for languageCode: String) -> String {
        let map: [String: String] = [
            "ar": "🇪🇬",
            "bn": "🇧🇩",
            "bg": "🇧🇬",
            "zh": "🇨🇳",
            "hr": "🇭🇷",
            "cs": "🇨🇿",
            "da": "🇩🇰",
            "nl": "🇳🇱",
            "en": "🇺🇸",
            "fi": "🇫🇮",
            "fr": "🇫🇷",
            "de": "🇩🇪",
            "el": "🇬🇷",
            "he": "🇮🇱",
            "hi": "🇮🇳",
            "hu": "🇭🇺",
            "id": "🇮🇩",
            "it": "🇮🇹",
            "ja": "🇯🇵",
            "ko": "🇰🇷",
            "lv": "🇱🇻",
            "lt": "🇱🇹",
            "no": "🇳🇴",
            "pl": "🇵🇱",
            "pt": "🇵🇹",
            "ro": "🇷🇴",
            "ru": "🇷🇺",
            "sr": "🇷🇸",
            "sk": "🇸🇰",
            "sl": "🇸🇮",
            "es": "🇪🇸",
            "sv": "🇸🇪",
            "th": "🇹🇭",
            "tr": "🇹🇷",
            "uk": "🇺🇦",
            "vi": "🇻🇳"
        ]
        return map[languageCode] ?? "🏳️"
    }
}
