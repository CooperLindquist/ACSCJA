import SwiftUI
import WebKit

struct CalendarWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        
        // Enable scrolling
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        
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
        var parent: CalendarWebView
        
        init(_ parent: CalendarWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Inject JavaScript to hide everything above the district calendar section
            let jsScript = """
            (function() {
                var calendarElement = document.querySelector('#block-views-exp-calendar-page, #main-content, .calendar-container');
                if (calendarElement) {
                    // Remove all elements before the calendar section
                    let prev = calendarElement.previousElementSibling;
                    while (prev) {
                        let temp = prev;
                        prev = prev.previousElementSibling;
                        temp.remove();
                    }
                    // Scroll to the calendar section
                    calendarElement.scrollIntoView();
                }
            })();
            """
            webView.evaluateJavaScript(jsScript, completionHandler: { result, error in
                if let error = error {
                    print("JavaScript evaluation error: \(error.localizedDescription)")
                }
            })
        }
    }
}

struct ContentView: View {
    var body: some View {
        CalendarWebView(url: URL(string: "https://www.edenpr.org/experience/calendar")!)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
