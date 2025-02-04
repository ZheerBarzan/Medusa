//
//  FeedbackView.swift
//  Medusa
//
//  Created by zheer barzan on 4/2/25.
//

import SwiftUI

struct FeedbackView: View {
    var messageList: TimedMessageList
    var body: some View {
        VStack {
            if let activeMessage = messageList.activeMessage{
                Text("\(activeMessage.message)")
                    .font(.system(.headline, design: .monospaced))
                    .foregroundColor(.black)
                    .environment(\.colorScheme, .light)
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    FeedbackView(
        messageList: TimedMessageList()
    )
}
