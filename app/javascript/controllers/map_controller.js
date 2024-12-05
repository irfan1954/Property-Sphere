import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    this.map.once('idle', function () { this.map.resize() })
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup({
        closeButton: false,
        closeOnClick: false,
      }).setHTML(marker.info_window_html);

      const customMarker = document.createElement("div");
      customMarker.innerHTML = marker.marker_html;

      const mapMarker = new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .addTo(this.map);

      // Show popup on mouseenter
      customMarker.addEventListener("mouseenter", () => {
        popup.addTo(this.map);
        popup.setLngLat([marker.lng, marker.lat]);
      });

      customMarker.addEventListener("click", () => {
        window.location.href = marker.property_path;
      });

      // // Hide popup on mouseleave
      customMarker.addEventListener("mouseleave", () => {
        popup.remove();
      });
    });
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

}
