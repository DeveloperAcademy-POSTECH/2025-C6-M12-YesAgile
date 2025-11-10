//
//  PrivacyConsentView.swift
//  babyMoa
//
//  Created by 한건희 on 11/2/25.
//

import SwiftUI

struct PrivacyConsentView: View {
    @ObservedObject var coordinator: BabyMoaCoordinator
    
    var body: some View {
        VStack(spacing: 0) {
            VStack{
                Text("privacyPolicy.title")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 8)
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        
                        Group {
                            Text("privacyPolicy.intro")
                            Text("privacyPolicy.purpose.title").bold()
                            Text("privacyPolicy.purpose.content")
                            Text("privacyPolicy.purpose.memberManagement")
                        }
                        
                        Group {
                            Text("privacyPolicy.collection.title").bold()
                            Text("privacyPolicy.collection.items")
                            Text("privacyPolicy.collection.auto")
                            Text("privacyPolicy.collection.methods")
                        }
                        
                        Group {
                            Text("privacyPolicy.thirdParty.title").bold()
                            Text("privacyPolicy.thirdParty.rules")
                            Text("privacyPolicy.thirdParty.cases")
                        }
                        
                        Group {
                            Text("privacyPolicy.retention.title").bold()
                            Text("privacyPolicy.retention.rules")
                            Text("privacyPolicy.retention.records")
                        }
                        
                        Group {
                            Text("privacyPolicy.deletion.title").bold()
                            Text("privacyPolicy.deletion.content")
                        }
                    }
                    .padding()
                }
                
            }
        }
    }
}

#Preview {
    PrivacyConsentView(coordinator: BabyMoaCoordinator())
}
