String criptografar(String texto) {
  String strCod = '';
  if (texto.trim().length > 2) {
    int intRnd = 0, intLetra = 0;
    intRnd = 121;
    for (int i = 0; i < texto.trim().length; i++) {
      intLetra = texto.codeUnitAt(i);
      if ((intLetra + intRnd) > 253) {
        intLetra -= intRnd;
        strCod += ('!${String.fromCharCode(intLetra)}');
      } else {
        intLetra += intRnd;
        strCod += String.fromCharCode(intLetra);
      }
    }
    strCod =
        ((strCod.substring(0, 2) + String.fromCharCode(intRnd)) +
        strCod.substring(2, (strCod.length - 2)));
  }
  return strCod;
}

String descriptografar(String texto) {
  String strTexto = texto, strCod = '';
  int intRnd = 0, intLetra = 0;
  if (texto.length > 2) {
    intRnd = texto.codeUnitAt(2);
    texto = (texto.substring(0, 2) + texto.substring(3, texto.length));
    for (int i = 0; i < texto.length; i++) {
      intLetra = texto.codeUnitAt(i);
      if (intLetra == 33) {
        i++;
        intLetra = (texto.codeUnitAt(i) + intRnd);
      } else {
        intLetra = (intLetra - intRnd);
      }
      if (intLetra < 1) {
        strCod += strTexto;
        break;
      }
      strCod += String.fromCharCode(intLetra);
    }
  }
  return strCod;
}
