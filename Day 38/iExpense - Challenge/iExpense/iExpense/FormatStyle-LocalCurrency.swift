//
//  FormatStyle-LocalCurrency.swift
//  iExpense
//
//  Created by James Armer on 21/05/2023.
//

import Foundation

extension FormatStyle where Self == FloatingPointFormatStyle<Double>.Currency {
    static var localCurrency: Self {
        .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
}
