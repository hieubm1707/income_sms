class TelegramDefaultValue {
  TelegramDefaultValue._();
  static final instance = TelegramDefaultValue._();

  late String env;

  String getChatId() {
    if (env == 'dev') {
      return '-1002171197915';
    }
    return '-1002214420524';
  }

  String getApiToken() {
    if (env == 'dev') {
      return '6804110841:AAHeCt27SnNU_2-nWV2xbSQK8C1qJJ_dCLc';
    }
    return '7364065957:AAGB_LsSU1XLfcRvNXU1X85YglLIzQxMIZY';
  }

  void init(String env) {
    this.env = env;
  }
}
