class ProductValidator {
  String validateImage(images) {
    if (images.isEmpty) return "Adicione pelo menos 1 (uma) imagem ao produto";
    return null;
  }

  String validateTitle(text) {
    if (text.isEmpty) return "Preencha o título do produto";
    return null;
  }

  String validateDescription(text) {
    if (text.isEmpty) return "Preencha a descrição do produto";
    return null;
  }

  String validatePrice(text) {
    double price = double.tryParse(text);
    if (price != null) {
      if (!text.contains('.') || text.split('.')[1].length != 2)
        return "Utilize 2 casas decimais";
    } else {
      return "Preço inválido!";
    }
    return null;
  }
}
