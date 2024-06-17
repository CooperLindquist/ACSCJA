import SwiftUI
import WebKit

struct CustomWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        
        // Disable scrolling
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: CustomWebView
        
        init(_ parent: CustomWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Inject JavaScript to hide unwanted parts of the page
            let jsScript = """
            document.querySelectorAll('header, footer, .other-sections, .ads, .contact-us').forEach(e => e.style.display = 'none');
            document.querySelector('.desired-section').scrollIntoView();
            """
            webView.evaluateJavaScript(jsScript, completionHandler: nil)
        }
    }
}
