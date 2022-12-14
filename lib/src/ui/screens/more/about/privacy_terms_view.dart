import 'package:davar/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PrivacyTermsView extends StatelessWidget {
  const PrivacyTermsView( this._futureReadStatement, {Key? key}) : super(key: key);

  final Future<String> _futureReadStatement;
  static const String _noInfo = 'Sorry! The information is not available at the moment';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
              initialData: 'Loading...',
              future: _futureReadStatement.timeout(const Duration(seconds: 4),
                  onTimeout: () => _noInfo),
              builder: (context, snapshot) {
                final bool snapHasError = snapshot.hasError;
                ConnectionState connection = snapshot.connectionState;
                if (connection == ConnectionState.done && !snapHasError) {
                  return _buildContent(context, snapshot);
                }
                if (snapHasError) {
                  return const Center(
                      child: LinearLoadingWidget(isError: true, info: 'Sorry! Please try again'));
                }
                return const Center(child: CircularProgressIndicator.adaptive());
              }),
        ),
      );
    /*});*/
  }

  Widget _buildContent(
      BuildContext context, AsyncSnapshot<String> snapshot) {
    String txt = _noInfo;
    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
      txt = snapshot.data!;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(txt),
    );
  }
}
