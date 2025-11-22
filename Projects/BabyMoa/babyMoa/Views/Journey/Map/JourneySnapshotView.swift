import SwiftUI
import MapKit

struct JourneySnapshotView: View {
    let centerCoordinate: CLLocationCoordinate2D
    let onTap: () -> Void

    var body: some View {
        ZStack {
            // Invisible rectangle to capture taps
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle()) // Ensure it has a shape for hit testing
                .onTapGesture(perform: onTap)

            Map(initialPosition: .region(MKCoordinateRegion(
                center: centerCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )))
            .ignoresSafeArea()
            .allowsHitTesting(false) // Disable interaction for the map itself
        }
        .frame(height: 200)
        .cornerRadius(16)
        .clipped() // Clip the map to the rounded corners
    }
}

#Preview {
    JourneySnapshotView(
        centerCoordinate: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        onTap: { print("Snapshot tapped") }
    )
    .padding()
}
