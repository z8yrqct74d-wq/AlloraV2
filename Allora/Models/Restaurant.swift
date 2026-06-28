import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: String
}

struct TimeSlot: Identifiable {
    let id = UUID()
    let time: String
    let available: Bool
}

struct Restaurant: Identifiable {
    let id: String
    let name: String
    let kind: String
    let area: String
    let dist: String
    let walk: String
    let priceLevel: Int
    let priceNote: String
    let availNote: String
    let role: String
    let roleColor: Color
    let reason: String
    let note: String
    let rating: String
    let ratingCount: String
    let lovedFor: [String]
    let vibe: String
    let confirmedLive: Bool
    let address: String
    let times: [TimeSlot]
    let menu: [MenuItem]
    let imageName: String

    var priceOn: String { String(repeating: "€", count: priceLevel) }
    var priceOff: String { String(repeating: "€", count: 4 - priceLevel) }
}

// MARK: - Data
extension Restaurant {
    static let all: [String: Restaurant] = {
        var d: [String: Restaurant] = [:]
        d["mat"] = Restaurant(
            id: "mat", name: "MAT", kind: "Modern Romanian", area: "Lipscani",
            dist: "650 m", walk: "8 min walk", priceLevel: 2, priceNote: "~180 lei for two",
            availNote: "20:00 tonight", role: "Best match", roleColor: Color(hex: "#BC5230"),
            reason: "Warm, low-lit, and made for two — and they're holding a 20:00 table eight minutes from you.",
            note: "A small, low-lit room where the evening slows down.",
            rating: "4.8", ratingCount: "612", lovedFor: ["Candlelight", "Service", "Wine list"],
            vibe: "Intimate · Candlelit · Unhurried",
            confirmedLive: true, address: "Strada Șelari 9, Lipscani",
            times: [.init(time: "18:30", available: true), .init(time: "19:00", available: true),
                    .init(time: "19:30", available: false), .init(time: "20:00", available: true),
                    .init(time: "20:30", available: true), .init(time: "21:30", available: true)],
            menu: [.init(name: "Plăcintă cu brânză", description: "Warm cheese pie, smoked butter", price: "32 lei"),
                   .init(name: "Sarmale", description: "Slow-cooked cabbage rolls, polenta", price: "46 lei"),
                   .init(name: "Rață cu vișine", description: "Duck leg, sour cherries, celeriac", price: "72 lei"),
                   .init(name: "Papanași", description: "Fried doughnuts, soured cream, jam", price: "34 lei")],
            imageName: "r-mat"
        )
        d["kane"] = Restaurant(
            id: "kane", name: "Kané", kind: "Italian trattoria", area: "Dorobanți",
            dist: "1.3 km", walk: "16 min walk", priceLevel: 2, priceNote: "~210 lei for two",
            availNote: "20:15 tonight", role: "Safest choice", roleColor: Color(hex: "#5E7048"),
            reason: "A sure thing — consistently loved, familiar plates, and a calm room for an easy evening.",
            note: "The kind of table you never regret choosing.",
            rating: "4.7", ratingCount: "1,140", lovedFor: ["Consistency", "Pasta", "Calm"],
            vibe: "Relaxed · Classic · Easy",
            confirmedLive: true, address: "Strada Radu Beller 12, Dorobanți",
            times: [.init(time: "19:00", available: true), .init(time: "19:30", available: true),
                    .init(time: "20:00", available: true), .init(time: "20:15", available: true),
                    .init(time: "20:45", available: true), .init(time: "21:30", available: true)],
            menu: [.init(name: "Burrata Pugliese", description: "Stracciatella, olive oil, basil", price: "48 lei"),
                   .init(name: "Cacio e pepe", description: "Tonnarelli, pecorino, pepper", price: "54 lei"),
                   .init(name: "Tiramisù", description: "The house classic", price: "30 lei")],
            imageName: "r-kane"
        )
        d["noua"] = Restaurant(
            id: "noua", name: "Noua", kind: "Small plates & wine", area: "Old Town",
            dist: "1.6 km", walk: "20 min walk", priceLevel: 3, priceNote: "~260 lei for two",
            availNote: "20:30 tonight", role: "Something different", roleColor: Color(hex: "#8A3450"),
            reason: "A little unexpected — a candle-and-vinyl wine room you probably haven't tried, still open tonight.",
            note: "Low light, natural wine, and records that keep getting better.",
            rating: "4.6", ratingCount: "318", lovedFor: ["Wine", "Atmosphere", "Music"],
            vibe: "Atmospheric · Lively · Memorable",
            confirmedLive: false, address: "Strada Covaci 4, Old Town",
            times: [.init(time: "20:00", available: true), .init(time: "20:30", available: true),
                    .init(time: "21:00", available: true), .init(time: "21:30", available: true),
                    .init(time: "22:00", available: true)],
            menu: [.init(name: "Beef tartare", description: "Smoked egg yolk, rye", price: "52 lei"),
                   .init(name: "Grilled mackerel", description: "Fermented chilli, herbs", price: "58 lei"),
                   .init(name: "Pét-nat, by the glass", description: "Ask for tonight's pour", price: "34 lei")],
            imageName: "r-noua"
        )
        d["sare"] = Restaurant(
            id: "sare", name: "Sare & Foc", kind: "Live-fire grill", area: "Floreasca",
            dist: "2.2 km", walk: "9 min drive", priceLevel: 3, priceNote: "~300 lei for two",
            availNote: "21:00 tonight", role: "Pick of the night", roleColor: Color(hex: "#DC5E2D"),
            reason: "Open kitchen, oak smoke, and a room that hums by nine.",
            note: "Oak smoke, open flame, and a room that hums by nine.",
            rating: "4.8", ratingCount: "540", lovedFor: ["Fire", "Energy", "Steak"],
            vibe: "Warm · Buzzy · Generous",
            confirmedLive: true, address: "Calea Floreasca 60",
            times: [.init(time: "20:30", available: true), .init(time: "21:00", available: true),
                    .init(time: "21:30", available: true), .init(time: "22:00", available: true)],
            menu: [.init(name: "Fire-roasted leeks", description: "Hazelnut, brown butter", price: "40 lei"),
                   .init(name: "Dry-aged ribeye", description: "Oak coals, bone marrow", price: "120 lei"),
                   .init(name: "Burnt honey tart", description: "Crème fraîche", price: "36 lei")],
            imageName: "r-sare"
        )
        d["lumina"] = Restaurant(
            id: "lumina", name: "Lumina", kind: "Natural wine bar", area: "Cotroceni",
            dist: "900 m", walk: "11 min walk", priceLevel: 2, priceNote: "~170 lei for two",
            availNote: "20:30 tonight", role: "Wine room", roleColor: Color(hex: "#5F529A"),
            reason: "Tiny, golden-lit, and pouring something interesting by the glass.",
            note: "A tiny golden room that smells of cork and candle.",
            rating: "4.7", ratingCount: "276", lovedFor: ["Wine", "Cheese", "Cosy"],
            vibe: "Snug · Golden · Quiet",
            confirmedLive: true, address: "Strada Dr. Lister 4, Cotroceni",
            times: [.init(time: "19:30", available: true), .init(time: "20:00", available: true),
                    .init(time: "20:30", available: true), .init(time: "21:00", available: true)],
            menu: [.init(name: "Cheese & charcuterie", description: "Local makers, daily pick", price: "64 lei"),
                   .init(name: "Whipped cod roe", description: "Grilled sourdough", price: "38 lei"),
                   .init(name: "Skin-contact, by the glass", description: "Tonight's pour", price: "32 lei")],
            imageName: "r-lumina"
        )
        d["oraopt"] = Restaurant(
            id: "oraopt", name: "Ora Opt", kind: "Date-night dining", area: "Armenească",
            dist: "1.1 km", walk: "14 min walk", priceLevel: 3, priceNote: "~280 lei for two",
            availNote: "20:00 tonight", role: "For two", roleColor: Color(hex: "#C96E5C"),
            reason: "Soft light, a quiet corner, and a menu built for lingering.",
            note: "Made for the evenings you want to remember.",
            rating: "4.9", ratingCount: "430", lovedFor: ["Romance", "Light", "Service"],
            vibe: "Romantic · Hushed · Soft",
            confirmedLive: true, address: "Strada Armenească 22",
            times: [.init(time: "19:30", available: true), .init(time: "20:00", available: true),
                    .init(time: "20:30", available: true), .init(time: "21:00", available: true)],
            menu: [.init(name: "Oysters, three ways", description: "Mignonette, lemon, hot", price: "66 lei"),
                   .init(name: "Lamb, slow & pink", description: "Smoked aubergine", price: "88 lei"),
                   .init(name: "Chocolate nemesis", description: "For two", price: "42 lei")],
            imageName: "r-oraopt"
        )
        d["verde"] = Restaurant(
            id: "verde", name: "Verde", kind: "Garden terrace", area: "Cișmigiu",
            dist: "1.4 km", walk: "17 min walk", priceLevel: 2, priceNote: "~160 lei for two",
            availNote: "Terrace open", role: "New on Allora", roleColor: Color(hex: "#3F8060"),
            reason: "A leafy courtyard that stays warm long after sunset.",
            note: "A leafy courtyard that holds the day's last warmth.",
            rating: "4.6", ratingCount: "92", lovedFor: ["Garden", "Air", "Calm"],
            vibe: "Leafy · Open · Easy",
            confirmedLive: false, address: "B-dul Schitu Măgureanu 3, Cișmigiu",
            times: [.init(time: "19:00", available: true), .init(time: "19:30", available: true),
                    .init(time: "20:00", available: true), .init(time: "20:30", available: true)],
            menu: [.init(name: "Garden salad", description: "Market greens, herbs", price: "34 lei"),
                   .init(name: "Grilled trout", description: "Charred lemon", price: "62 lei"),
                   .init(name: "Elderflower tart", description: "Seasonal", price: "30 lei")],
            imageName: "r-verde"
        )
        d["cuib"] = Restaurant(
            id: "cuib", name: "Cuib", kind: "Hideaway bistro", area: "Mântuleasa",
            dist: "1.8 km", walk: "22 min walk", priceLevel: 2, priceNote: "~190 lei for two",
            availNote: "20:45 tonight", role: "Hidden gem", roleColor: Color(hex: "#615C52"),
            reason: "Eight tables behind an unmarked door — locals keep it quiet.",
            note: "Eight tables, one candle each, no sign on the door.",
            rating: "4.8", ratingCount: "150", lovedFor: ["Secret", "Cosy", "Food"],
            vibe: "Secret · Tiny · Warm",
            confirmedLive: false, address: "Strada Mântuleasa 7",
            times: [.init(time: "20:00", available: true), .init(time: "20:45", available: true),
                    .init(time: "21:15", available: true)],
            menu: [.init(name: "Bone marrow toast", description: "Pickled shallot", price: "40 lei"),
                   .init(name: "Wild mushroom orzo", description: "Aged cheese", price: "52 lei"),
                   .init(name: "Quince & cream", description: "House dessert", price: "28 lei")],
            imageName: "r-cuib"
        )
        d["foaie"] = Restaurant(
            id: "foaie", name: "Foaie", kind: "All-day bistro", area: "Universitate",
            dist: "1.1 km", walk: "14 min walk", priceLevel: 1, priceNote: "~120 lei for two",
            availNote: "20:15 tonight", role: "Easy & nearby", roleColor: Color(hex: "#B57E36"),
            reason: "Unfussy, generous, and almost always has a table.",
            note: "Big windows, good bread, no fuss.",
            rating: "4.5", ratingCount: "880", lovedFor: ["Bread", "Value", "Light"],
            vibe: "Bright · Casual · Generous",
            confirmedLive: true, address: "Strada Edgar Quinet 5",
            times: [.init(time: "19:00", available: true), .init(time: "19:30", available: true),
                    .init(time: "20:00", available: true), .init(time: "20:15", available: true),
                    .init(time: "21:00", available: true)],
            menu: [.init(name: "Tartine of the day", description: "Ask your server", price: "28 lei"),
                   .init(name: "Roast chicken, half", description: "Lemon, potatoes", price: "58 lei"),
                   .init(name: "Seasonal galette", description: "Whatever's ripe", price: "26 lei")],
            imageName: "r-foaie"
        )
        return d
    }()

    static let shortlist: [Restaurant] = [all["mat"]!, all["kane"]!, all["noua"]!]
    static let pickOfNight: Restaurant = all["sare"]!
}
