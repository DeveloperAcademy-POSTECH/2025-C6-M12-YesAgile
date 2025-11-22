//
//  JourneyMapView.swift
//  babyMoa
//
//  Created by pherd on 11/21/25.
//

import MapKit
import SwiftUI

struct JourneyMapView: View {
    // MARK: - Properties
    @Binding var isPresented: Bool
    @State var viewModel: JourneyMapViewModel

    init(
        isPresented: Binding<Bool>,
        initialPosition: MapCameraPosition // Changed to accept directly
    ) {
        self._isPresented = isPresented
        // ViewModel will take initialPosition
        self._viewModel = State(initialValue: JourneyMapViewModel(initialPosition: initialPosition))
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $viewModel.position) {
                if let userLocation = viewModel.userLocation {
                    Annotation("내 위치", coordinate: userLocation.coordinate) {
                        UserLocationMarker()
                    }
                }
                
                // Display mock annotations
                ForEach(viewModel.mockAnnotations, id: \.latitude) { coordinate in // Using latitude for unique ID for mock
                    Annotation("", coordinate: coordinate) {
                        JourneyMapMarkerView(image: Image(systemName: "mappin.circle.fill")) // Hardcoded placeholder
                    }
                }
            }
            .mapStyle(.standard)
            
            // Close Button
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            }
            .padding(.top, 60)
            .padding(.trailing, 20)
            
            // Map Controls
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: viewModel.moveToCurrentLocation) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                            .frame(width: 48, height: 48)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                }
            }
            .padding(.bottom, 40)
            .padding(.trailing, 20)
        }
        .ignoresSafeArea()
        .onAppear(perform: viewModel.onAppear)
    }
}

// MARK: - Subviews

struct UserLocationMarker: View {
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 18, height: 18)
            .overlay(Circle().stroke(Color.white, lineWidth: 3))
            .shadow(radius: 3)
    }
}
