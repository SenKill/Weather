//
//  RefreshableScrollView.swift
//  Weather
//
//  Created by Serik Musaev on 12/19/21.
//

import SwiftUI

struct RefreshableScrollView<Content: View>: UIViewRepresentable {
    
    var content: Content
    var onRefresh: (UIRefreshControl) -> ()
    var refreshControl = UIRefreshControl()
    
    init(@ViewBuilder content: @escaping ()-> Content,onRefresh: @escaping (UIRefreshControl) -> ()) {
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let uiscrollView = UIScrollView()
        
        // Refresh customization
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.tintColor = .blue
        refreshControl.addTarget(context.coordinator, action: #selector(context.coordinator.onRefresh), for: .valueChanged)
        
        setUpView(uiscrollView: uiscrollView)
        
        uiscrollView.refreshControl = refreshControl
        
        return uiscrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        setUpView(uiscrollView: uiView)
    }
    
    func setUpView(uiscrollView: UIScrollView) {
        let hostView = UIHostingController(rootView: content.frame(maxHeight: .infinity, alignment: .top))
        
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            hostView.view.topAnchor.constraint(equalTo: uiscrollView.topAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: uiscrollView.bottomAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: uiscrollView.trailingAnchor),
            
            hostView.view.widthAnchor.constraint(equalTo: uiscrollView.widthAnchor),
            hostView.view.heightAnchor.constraint(greaterThanOrEqualTo: uiscrollView.heightAnchor, constant: 1)
        ]
        
        uiscrollView.subviews.last?.removeFromSuperview()
        uiscrollView.addSubview(hostView.view)
        uiscrollView.addConstraints(constraints)
    }
    
    class Coordinator: NSObject {
        var parent: RefreshableScrollView
        
        init(parent: RefreshableScrollView) {
            self.parent = parent
        }
        
        @objc func onRefresh() {
            parent.onRefresh(parent.refreshControl)
        }
    }
}

struct RefreshableScrollViewTest: View {
    @State var count: Int = 5
    
    
    var body: some View {
        NavigationView {
            RefreshableScrollView(content: {
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 3), spacing: 3, content: {
                    ForEach(1...count, id: \.self) { index in
                        Color.red
                            .frame(height: 183)
                            .overlay(Text("\(index)").font(.largeTitle))
                    }
                })
                .padding()
                
            }, onRefresh: { control in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.count += 3
                    control.endRefreshing()
                }
            })
            .navigationTitle("Pull it down")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RefreshableScrollView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshableScrollViewTest()
    }
}
