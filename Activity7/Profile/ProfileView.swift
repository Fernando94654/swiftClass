import SwiftUI

struct ProfileView: View {

    let avatars = ["Avatar1", "Avatar2", "Avatar3"]
    @State private var selectedAvatar = "Avatar1"
    @State private var zoomLevel: CGFloat = 1.0
    @State private var backgroundColor: Color = .gray
    @State private var age = 18
    @State private var isProfilePublic = false
    @State private var notificationsEnabled = false

    var body: some View {
        VStack {
            Text("Perfil")
                .font(.largeTitle)
                .bold()

            Image(selectedAvatar)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .background(Circle().fill(backgroundColor.opacity(0.8)).frame(width: 200))
                .clipShape(Circle())
                .shadow(radius: 5)
                .scaleEffect(zoomLevel)
                .padding()

            Picker("Elige tu avatar", selection: $selectedAvatar) {
                ForEach(avatars, id: \.self) { avatar in
                    Text(avatar)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            HStack {
                Text("Zoom a Imagen:")
                Slider(value: $zoomLevel, in: 1...1.3, step: 0.1)
            }
            .padding()

            ColorPicker("Selecciona Color Fondo Avatar", selection: $backgroundColor)
                .padding()

            Stepper("Edad: \(age)", value: $age, in: 10...100)
                .padding()

            Divider()

            Toggle(isOn: $isProfilePublic) {
                Text(isProfilePublic ? "Perfil Público" : "Perfil Privado")
            }
            .padding()

            Toggle(isOn: $notificationsEnabled) {
                Text(notificationsEnabled ? "Notificaciones Activadas" : "Notificaciones Desactivadas")
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
