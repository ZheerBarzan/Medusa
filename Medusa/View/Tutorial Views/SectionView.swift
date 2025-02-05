//
//  SectionView.swift
//  Medusa
//
//  Created by zheer barzan on 5/2/25.
//

import SwiftUI

struct SectionView: View {
    let sections : [Section]
    
    private let sectionHeight = 120.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
                    ForEach(sections) { section in
                        VStack(alignment: .leading) {
                            Divider()
                                .padding([.bottom, .trailing], 5.0)

                            HStack {
                                Text(section.title)
                                    .bold()

                                Spacer()

                                if let symbol = section.symbol, let symbolColor = section.symbolColor {
                                    Text(Image(systemName: symbol))
                                        .bold()
                                        .foregroundColor(symbolColor)
                                }
                            }

                            ForEach(section.body, id: \.self) { line in
                                Text(line)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer()
                        }
                        .frame(height: sectionHeight)
                    }
                }

                Spacer()
            }
        }

