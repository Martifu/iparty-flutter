library interactive_maps_marker; // interactive_marker_list

import 'dart:async';
import 'dart:typed_data';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iparty/src/utils/utils.dart';

class MarkerItem {
  int id;
  double latitude;
  double longitude;

  MarkerItem({this.id, this.latitude, this.longitude});
}

// ignore: must_be_immutable
class InteractiveMapsMarker extends StatefulWidget {
  final LatLng center;
  final double itemHeight;
  final double zoom;
  @required
  List<MarkerItem> items;
  @required
  final IndexedWidgetBuilder itemContent;

  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry itemPadding;

  InteractiveMapsMarker({
    this.items,
    this.itemBuilder,
    this.center = const LatLng(0.0, 0.0),
    this.itemContent,
    this.itemHeight = 116,
    this.zoom = 12.0,
    this.itemPadding = const EdgeInsets.only(bottom: 60.0),
  });

  Uint8List markerIcon;
  Uint8List markerIconSelected;

  @override
  _InteractiveMapsMarkerState createState() => _InteractiveMapsMarkerState();
}

class _InteractiveMapsMarkerState extends State<InteractiveMapsMarker> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  

  PageController pageController = PageController(viewportFraction: 0.9);

  Set<Marker> markers;
  int currentIndex = 0;
  ValueNotifier selectedMarker = ValueNotifier<int>(null);
  String _mapStyle;
  @override
  void initState() {
    rebuildMarkers(currentIndex);
    rootBundle.loadString('assets/json_assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    rebuildMarkers(currentIndex);
    super.didChangeDependencies();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controller.complete(controller);
    mapController.setMapStyle(_mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      initialData: 0,
      builder: (context, snapshot) {
        return Stack(
          children: <Widget>[
            _buildMap(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: widget.itemPadding,
                child: SizedBox(
                  height: widget.itemHeight,
                  child: PageView.builder(
                    itemCount: widget.items.length,
                    controller: pageController,
                    onPageChanged: _pageChanged,
                    itemBuilder: widget.itemBuilder != null ? widget.itemBuilder : _buildItem,
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * .06, horizontal: Get.width * .04),
                child: Material(color: Colors.transparent, child: IconButton(icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white), onPressed: (){Get.back();})),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMap() {
    return Positioned.fill(
      child: ValueListenableBuilder(
        valueListenable: selectedMarker,
        builder: (context, value, child) {
          return GoogleMap(
            zoomControlsEnabled: false,
            markers: value == null ? null : markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.center,
              zoom: widget.zoom,
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(context, i) {
    return Transform.scale(
      scale: i == currentIndex ? 1 : 0.9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: widget.itemHeight,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                offset: Offset(0.5, 0.5),
                color: Color(0xff000000).withOpacity(0.12),
                blurRadius: 20,
              ),
            ],
          ),
          child: widget.itemContent(context, i),
        ),
      ),
    );
  }

  void _pageChanged(int index) {
    setState(() => currentIndex = index);
    Marker marker = markers.elementAt(index);
    rebuildMarkers(index);

    mapController
        .animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: marker.position, zoom: 15),
      ),
    )
        .then((val) {
      setState(() {});
    });
  }

  Future<void> rebuildMarkers(int index) async {
    int current = widget.items[index].id;

    if (widget.markerIcon == null) widget.markerIcon = await getBytesFromAsset('assets/img/marker.png', 100);
    if (widget.markerIconSelected == null) widget.markerIconSelected = await getBytesFromAsset('assets/img/marker_selected.png', 100);

    Set<Marker> _markers = Set<Marker>();

    widget.items.forEach((item) {
      _markers.add(
        Marker(
          markerId: MarkerId(item.id.toString()),
          position: LatLng(item.latitude, item.longitude),
          onTap: () {
            int tappedIndex = widget.items.indexWhere((element) => element.id == item.id);
            pageController.animateToPage(
              tappedIndex,
              duration: Duration(milliseconds: 300),
              curve: Curves.bounceInOut,
            );
            _pageChanged(tappedIndex);
          },
          icon: item.id == current ? BitmapDescriptor.fromBytes(widget.markerIconSelected) : BitmapDescriptor.fromBytes(widget.markerIcon),
        ),
      );
    });

    setState(() {
      markers = _markers;
    });
    selectedMarker.value = current;
  }
}
