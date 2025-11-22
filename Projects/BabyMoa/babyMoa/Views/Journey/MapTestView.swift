import SwiftUI
import MapKit

struct MapTestView: View {
    @State private var showMap = true
    var body: some View {
        Text("Map Test View")
            .fullScreenCover(isPresented: $showMap) {
                JourneyMapView(
                    isPresented: $showMap,
                    initialPosition: .region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    ))
                )
            }
    }
}

#Preview {
    MapTestView()
}
