

class RequestConvert{

  static String convertTo(String input){
    return input.replaceAll('\"', '\'').replaceAll('{', '@').replaceAll('}', '~').replaceAll(':', '&');
  }

  static String convertFrom(String input){
    return input.replaceAll('\'', '\"').replaceAll('@', '{').replaceAll('~', '}').replaceAll('&', ':');
  }
}