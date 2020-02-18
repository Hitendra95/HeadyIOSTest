//
//  DataModal.swift
//  Heady iOS Test
//
//  Created by Hitendra Dubey on 17/02/20.
//  Copyright © 2020 Hitendra Dubey. All rights reserved.
//

import Foundation

//// MARK: - Empty
struct MoviesDataResponse: Codable{
    let total_results, page, total_pages: Int?
    let results: [Result]?

}

// MARK: - Result
struct Result: Codable {
    //let adult: Bool
    let original_language: String?
    let backdrop_path, title: String?
    let vote_count: Int?
    let original_title, overview: String?
    let vote_average: Double?
    let video: Bool?
    let id: Int?
    let popularity: Double?
    let genre_ids: [Int]?
    let release_date, poster_path: String?

}

// MARK: - Empty
struct MovieDetailAPIResponse: Codable {
    let revenue: Int?
    let release_date: String?
    let popularity: Double?
    let tagline: String?
    let production_companies: [ProductionCompany]?
    let backdrop_path, imdb_id, title, original_title: String?
    let genres: [Genre]?
    let original_language: String?
    let vote_count, id: Int?
    let status: String?
    let homepage, overview: String?
    let video: Bool?
    let runtime, budget: Int?
    let poster_path: String?
    let vote_average: Double?
    let adult: Bool?

}

// MARK: - Genre
struct Genre: Codable {
    let name: String?
    let id: Int?
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let logoPath: String?
    let id: Int?
    let name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case logoPath = "logo_path"
        case id, name
        case originCountry = "origin_country"
    }
}
