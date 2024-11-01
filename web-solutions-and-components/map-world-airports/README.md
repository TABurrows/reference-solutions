# Map: World Airports


A simple web application using the leaflet mapping package.


```jsx
import { LatLngExpression } from "leaflet";
import { MapContainer, TileLayer, Marker, Popup, ZoomControl } from "react-leaflet";

import "leaflet/dist/leaflet.css";

const point: LatLngExpression = [51.505, -0.09];

export default function() {

    return (
        <MapContainer zoomControl={false} center={point} zoom={7} scrollWheelZoom={false} style={{height: "100vh", width: "100vw"}}>
            <ZoomControl position="bottomright" />
            <TileLayer
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            />
            <Marker position={point}>
                <Popup>
                A pretty CSS3 popup. <br /> Easily customizable.
                </Popup>
            </Marker>
        </MapContainer>
    )
};
```

