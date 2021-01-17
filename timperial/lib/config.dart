import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static Color OUTLINE_COLOR = Colors.grey[500];
  static Color SECONDARY_COLOR = Color(0xffFCFCFC);
  static Color BACKGROUND_COLOR = Colors.white;
  static Color HIGHLIGHT_COLOR = Color(0xff718EDD);
  static Color INACTIVE_COLOR_DARK = Colors.grey[700];
  static Color INACTIVE_COLOR_LIGHT = Colors.white;
  static Color DARK_TEXT = Colors.black;
  static Color LIGHT_TEXT = Colors.white;
  static Color GREY_TEXT = Colors.grey[700];
  static Color BLUE_TEXT = Colors.blue[900];
  static Color ERROR_TEXT = Colors.red;
  static Color IMPERIAL_LIGHT_BLUE = Color(0xff006eaf);
  static Color IMPERIAL_MEDIUM_BLUE = Color(0xff003e74);
  static Color IMPERIAL_DARK_BLUE = Color(0xff002147);
  static Color UNSELECTED_ICON_COLOR = Colors.black;
  static Color SELECTED_ICON_COLOR = Color(0xff9f004e);

  static int MAX_IMAGE_SIZE = 7 * 1024 * 1024;
  static int SWIPE_ANIMATION_DURATION = 200; // length of full swipe animation in milliseconds

  static IconData EXPLORE_PAGE_ICON = Icons.search;
  static IconData SWIPE_PAGE_ICON = Icons.content_copy;
  static IconData PROFILE_PAGE_ICON = Icons.perm_identity;

  static IconData EXPLORE_PAGE_SELECTED_ICON = Icons.favorite;
  static IconData EXPLORE_PAGE_UNSELECTED_ICON = Icons.favorite;
  static IconData SWIPE_PAGE_SELECTED_ICON = Icons.whatshot;
  static IconData SWIPE_PAGE_UNSELECTED_ICON = Icons.whatshot;
  static IconData PROFILE_PAGE_SELECTED_ICON = Icons.person;
  static IconData PROFILE_PAGE_UNSELECTED_ICON = Icons.person;



  static IconData GRID = Icons.grid_on;
  static IconData DELETE_IMAGE_ICON = Icons.delete;
  static IconData ADD_IMAGE_ICON = Icons.add_a_photo;



  static String DEFAULT_PROFILE_PICTURE_LOCATION = 'gs://bloopr-test.appspot.com/app/images/profile_image_placeholder.png';
  static String EULA_AGREEMENT_TEXT = '''End-User License Agreement (EULA) of timperial
This End-User License Agreement ("EULA") is a legal agreement between you and Stok Industries. Our EULA was created by EULA Template for timperial.

This EULA agreement governs your acquisition and use of our timperial software ("Software") directly from Stok Industries or indirectly through a Stok Industries authorized reseller or distributor (a "Reseller"). Our Privacy Policy was created by the Privacy Policy Generator.

Please read this EULA agreement carefully before completing the installation process and using the timperial software. It provides a license to use the timperial software and contains warranty information and liability disclaimers.

If you register for a free trial of the timperial software, this EULA agreement will also govern that trial. By clicking "accept" or installing and/or using the timperial software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.

If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.

This EULA agreement shall apply only to the Software supplied by Stok Industries herewith regardless of whether other software is referred to or described herein. The terms also apply to any Stok Industries updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply.

License Grant
Stok Industries hereby grants you a personal, non-transferable, non-exclusive licence to use the timperial software on your devices in accordance with the terms of this EULA agreement.

You are permitted to load the timperial software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the timperial software.

You are not permitted to:

Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things
Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose
Allow any third party to use the Software on behalf of or for the benefit of any third party
Use the Software in any way which breaches any applicable local, national or international law
use the Software for any purpose that Stok Industries considers is a breach of this EULA agreement
Intellectual Property and Ownership
Stok Industries shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Stok Industries.

Stok Industries reserves the right to grant licences to use the Software to third parties.

Termination
This EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to Stok Industries.

It will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement.

Governing Law
This EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of gb.''';

  static TextStyle TEXT_STYLE_HEADER_DARK = GoogleFonts.getFont('Open Sans', color: DARK_TEXT, fontSize: 20.0);
  static TextStyle TEXT_STYLE_HEADER_GREY = GoogleFonts.getFont('Open Sans', color: GREY_TEXT, fontSize: 20.0);
  static TextStyle TEXT_STYLE_HEADER_HIGHLIGHT = GoogleFonts.getFont('Open Sans', color: HIGHLIGHT_COLOR, fontSize: 20.0);
  static TextStyle TEXT_STYLE_HEADER_LIGHT = GoogleFonts.getFont('Open Sans', color: LIGHT_TEXT, fontSize: 20.0);
  static TextStyle TEXT_STYLE_CAPTION_DARK = GoogleFonts.getFont('Open Sans', color: DARK_TEXT, fontSize: 16.0);
  static TextStyle TEXT_STYLE_CAPTION_LIGHT = GoogleFonts.getFont('Open Sans', color: LIGHT_TEXT, fontSize: 16.0);
  static TextStyle TEXT_STYLE_CAPTION_GREY = GoogleFonts.getFont('Open Sans', color: GREY_TEXT, fontSize: 16.0);
  static TextStyle TEXT_STYLE_BIO = GoogleFonts.getFont('Open Sans', color: BLUE_TEXT, fontSize: 24.0, fontWeight: FontWeight.w300);
  static TextStyle TEXT_STYLE_DARK = GoogleFonts.getFont('Open Sans', color: DARK_TEXT, fontWeight: FontWeight.w300);
  static TextStyle TEXT_STYLE_LIGHT = GoogleFonts.getFont('Open Sans', color: LIGHT_TEXT, fontWeight: FontWeight.w300);
  static TextStyle TEXT_STYLE_HINT_BLACK = GoogleFonts.getFont('Open Sans', color: DARK_TEXT, fontSize: 12.0);
  static TextStyle TEXT_STYLE_HINT_DARK = GoogleFonts.getFont('Open Sans', color: GREY_TEXT, fontSize: 14.0);
  static TextStyle TEXT_STYLE_HINT_LIGHT = GoogleFonts.getFont('Open Sans', color: LIGHT_TEXT, fontSize: 14.0);
  static TextStyle TEXT_STYLE_ERROR = GoogleFonts.getFont('Open Sans', color: ERROR_TEXT, fontSize: 12.0);
  static TextStyle TEXT_STYLE_LARGE_NUMBERS_DARK = GoogleFonts.getFont('Open Sans', color: DARK_TEXT, fontSize: 18.0, fontWeight:  FontWeight.w500);
  static TextStyle ACTION_SHEET_TITLE = GoogleFonts.getFont('Roboto', color: DARK_TEXT, fontSize: 15.0, fontWeight:  FontWeight.w900);
  static TextStyle ACTION_SHEET_TEXT = GoogleFonts.getFont('Roboto', color: DARK_TEXT, fontSize: 17.0, fontWeight:  FontWeight.w500);
  static TextStyle FLAT_BUTTON_STYLE = TextStyle(color: Constants.IMPERIAL_MEDIUM_BLUE, fontWeight: FontWeight.w800, fontSize: 16.5);
  static TextStyle FLAT_RED_BUTTON_STYLE = TextStyle(color: Constants.SELECTED_ICON_COLOR, fontWeight: FontWeight.w800, fontSize: 16.5);
}

enum language {
  english,
  spanish
}