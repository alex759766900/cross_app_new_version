import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:jemma/models/searchtradie.dart';
import 'package:new_cross_app/Home Page/constants.dart';
import 'package:new_cross_app/Home Page/decorations.dart';
import 'package:new_cross_app/Home Page/responsive.dart';

//import '../../routes.dart';

/// Widget which assist in users searching for trades-person, via job type and location.
///
/// Note: Needs to be stateful as to hold onto the dropdown info.
class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String buttoncontent;

    return Container(
      width: 40.pw(size),
      constraints: BoxConstraints(minWidth: 250),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: defaultShadows,
        borderRadius: BorderRadius.circular(35),
      ),

      // Contains dropdownButtons + Search button
      child: OverflowBar(
        overflowAlignment: OverflowBarAlignment.center,
        spacing: 2.5.pw(size),
        overflowSpacing: 1.75.ph(size),
        children: [
          DropDownContainer(topic:"Job type",topicIconData: Icons.handyman, dropDownContent: {},),
          DropDownContainer(topic:"Location",topicIconData: Icons.location_pin, dropDownContent: {},),
          _buildSearchButton(context)
        ],
      ),
    );
  }

  /// Search button which will be able initiate a search and assist in transitioning the screen to the result.
  Container _buildSearchButton(
      BuildContext context) {
    return Container(
      child: ElevatedButton.icon(
        onPressed: () {
         /* Navigator.of(context).pushNamed(Screen.result.getURL(),
              arguments: {"suburb":"Belconnen","jobType":"Electrician"});*/
        }, // TODO: Replace with search request
        icon: Icon(
          Icons.search,
          color: Colors.black,
          size: 18,
        ),
        label: Text(
          'Search',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(primary: kLogoColor, elevation: 2),
      ),
    );
  }
}

/// Reusable dropdown container that can host icons/images as well.
class DropDownContainer extends StatefulWidget {
  final String topic;
  final IconData topicIconData;
  final Map<String, Image> dropDownContent;

  // value get from droupdown button

  /// [topic] refers to the dropdownButton's topic; Example: Job type.
  /// [topicIconData] holds the topic's iconData.
  /// [dropDownContent] is the map which holds the dropdownItem's name and image.
  DropDownContainer({
    Key? key,
    required this.topic,
    required this.topicIconData,
    required this.dropDownContent,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DropDownContainerState(
      topic: topic,
      dropDownContent: dropDownContent,
      topicIconData: topicIconData);
}

class _DropDownContainerState extends State<DropDownContainer> {
  final String topic;
  final IconData topicIconData;
  final Map<String, Image> dropDownContent;
  String? _selectedOption;
  List<String> Location = [
    'Acton',
    'Aranda',
    'Belconnen',
    'Bonner',
    'Braddon',
    'Calwell',
    'Canberra',
    'Charnwood',
    'Crace',
    'Dickson',
    'Deakin',
    'Downer',
    'Evatt',
    'Florey',
    'Forde',
    'Forrest',
    'Franklin',
    'Fyshwick',
    'Garran',
    'Greenway',
    'Griffith',
    'Gungahlin',
    'Harrison',
    'Hawker',
    'Holt',
    'IsabellaPlains',
    'Jacka',
    'Kaleen',
    'Kambah',
    'Kingsrib',
    'Latham',
    'Lyneham'
  ];
  // List<String> JobType= ['Air-conditioning and Mechanical Services Plumber', 'Air-conditioning and Refrigeration Mechanic'
  //     'Arborist', 'Automotive Electrician', 'Boat Builder and Repairer', 'Bricklayer', 'Cabinetmaker','Carpenter', 'Carpenter and Joiner','Diesel Motor Mechanic'
  //     'Drainer', 'Electrician (General)', 'Electronic Equipment Tradesperson', 'Fibrous Plasterer', 'Floor Finisher', 'Furniture Finisher',
  //   'Gasfitter', 'Glazier', 'Hairdresser', 'Landscape Gardener', 'Locksmith', 'Motor Mechanics (General)', 'Motorcycle Mechanic',
  //   'Painting', 'Plumber (General)', 'Roof Plumber', 'Roof Tiler', 'Signwriter', 'Solid Plasterer', 'Stonemason', 'Upholsteror', 'Wall and Floor Tiler'
  // ];

  List<String> JobType = [
    'AirconMechanic',
    'BrickLayer',
    'Carpenter',
    'CarpetLayer',
    'Decking',
    'Electrcian',
    'Fencing',
    'GasPlumber',
    'Glazier',
    'HairAndMakeUp',
    'HomeRenovation',
    'Insulation'
  ];

  _DropDownContainerState({
    required this.topic,
    required this.topicIconData,
    required this.dropDownContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),

      // Just some decoration
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Colors.white10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              side: BorderSide(color: Colors.grey.withOpacity(0.45))),
        ),
        child: DropdownButton(
            value: _selectedOption,
            onChanged: (selection) => setState(() {
                  _selectedOption = selection.toString();
                }),



            hint: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Row(children: [
                Expanded(
                    flex: 2,
                    child: Icon(
                      topicIconData,
                      color: Colors.black,
                    )),
                Expanded(
                    flex: 4,
                    child: Text(
                      topic,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ))
              ]),
            ),
            isExpanded: true,
            underline: SizedBox(),
            items: topic == "Location"
                ? Location.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(children: [
                        Expanded(
                            flex: 2,
                            child: Icon(Icons.handyman_outlined,
                                color: Colors.black)),
                        Expanded(
                            flex: 4,
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ))
                      ]),
                    );
                  }).toList()
                : JobType.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(children: [
                        Expanded(
                            flex: 2,
                            child: Icon(Icons.handyman_outlined,
                                color: Colors.black)),
                        Expanded(
                            flex: 4,
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ))
                      ]),
                    );
                  }).toList()),
      ),
    );
  }
}
