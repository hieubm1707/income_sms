class TelegramDefaultValue {
  TelegramDefaultValue._();
  static final instance = TelegramDefaultValue._();

  late String env;

  String getChatId() {
    if (env == 'dev') {
      return '-1002171197915';
    }
    return '';
  }

  String getChatUrl() {
    if (env == 'dev') {
      return '6804110841:AAHeCt27SnNU_2-nWV2xbSQK8C1qJJ_dCLc';
    }
    return '6804110841:AAHeCt27SnNU_2-nWV2xbSQK8C1qJJ_dCLc';
  }

  void init(String env) {
    this.env = env;
  }
}
