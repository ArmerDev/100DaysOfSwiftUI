//
//  FormatStyle-LocalCurrency.swift
//  iExpense
//
//  Created by James Armer on 25/06/2023.
//

import Foundation

extension FormatStyle where Self == FloatingPointFormatStyle<Double>.Currency {
    static var localCurrency: Self {
        .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
}
