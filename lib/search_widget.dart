import 'package:flutter/material.dart';
import 'ui/flutter_flow/flutter_flow_theme.dart';
import 'ui/flutter_flow/flutter_flow_util.dart';
import 'ui/flutter_flow/flutter_flow_widgets.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 10.0, 8.0, 10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 5.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 2.0),
            )
          ],
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: widget.hintText,
            labelStyle: FlutterFlowTheme.of(context).bodySmall.override(
              fontFamily: 'Outfit',
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            hintText: '',
            hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Lexend Deca',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primaryBackground,
                width: 0.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primaryText,
                width: 0.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0x00000000),
                width: 0.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0x00000000),
                width: 0.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 20.0, 24.0),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Outfit',
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
