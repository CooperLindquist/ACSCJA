//
//  ActivitesView.swift
//  ACSCJA
//
//  Created by 90310805 on 4/11/24.
//

import SwiftUI
import WebKit
struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
struct ActivitesView: View {
    var body: some View {
          NavigationView {
              WebView(urlString: "https://www.edenpr.org/eden-prairie-high-school/activitiesathletics/activities-office")
                  
          }
          .ignoresSafeArea()
      }
  }
#Preview {
    ActivitesView()
}
