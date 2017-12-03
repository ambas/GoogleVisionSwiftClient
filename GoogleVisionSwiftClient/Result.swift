//
//  Result.swift
//  GoogleVisionSwiftClient
//
//  Created by Ambas Chobsanti on 8/12/17.
//  Copyright © 2017 Ambas. All rights reserved.
//

public enum Result<T> {
    case success(T)
    case error(ExtractDataError)
}
