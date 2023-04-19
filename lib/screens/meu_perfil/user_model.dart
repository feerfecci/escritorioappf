// ignore: file_names

// ignore_for_file: non_constant_identifier_names

class UserModel {
  final String responsavel;
  final String email_principal;
  // final String email;
  final String cep;
  final String endereco;
  final String numero;
  final String complemento;
  final String bairro;
  final String cidade;
  final String estado;
  //dados cobraça
  final String nome_iugu;
  final String telefone_cobranca;
  final String email_cobranca;
  final String cep_cobranca;
  final String endereco_cobranca;
  final String numero_cobranca;
  final String complemento_cobranca;
  final String bairro_cobranca;
  final String cidade_cobranca;
  final String estado_cobranca;
  //dados app
  final String razao_social_pf;
  final String razao_social;
  final String nome_fantasia;
  final String telefone1;
  final String telefone2;
  //adicionais
  final String responsavel2;
  final String email2;
  final String responsavel3;
  final String email3;
  final String responsavel4;
  final String email4;
  final String responsavel5;
  final String email5;
  //senhas
  final String novaSenha;

  UserModel({
    this.responsavel = '',
    this.email_principal = '',
    // this.email = '',
    this.cep = '',
    this.endereco = '',
    this.numero = '',
    this.complemento = '',
    this.bairro = '',
    this.cidade = '',
    this.estado = '',
    //dados cobraça
    this.nome_iugu = '',
    this.telefone_cobranca = '',
    this.email_cobranca = '',
    this.cep_cobranca = '',
    this.endereco_cobranca = '',
    this.numero_cobranca = '',
    this.complemento_cobranca = '',
    this.bairro_cobranca = '',
    this.cidade_cobranca = '',
    this.estado_cobranca = '',
    //dados app
    this.razao_social_pf = '',
    this.razao_social = '',
    this.nome_fantasia = '',
    this.telefone1 = '',
    this.telefone2 = '',
    //adicionais

    this.responsavel2 = '',
    this.email2 = '',
    this.responsavel3 = '',
    this.email3 = '',
    this.responsavel4 = '',
    this.email4 = '',
    this.responsavel5 = '',
    this.email5 = '',

    //senhas
    this.novaSenha = '',
  });

  UserModel copyWith(
      {String? responsavel,
      String? email_principal,
      String? cep,
      String? endereco,
      String? numero,
      String? complemento,
      String? bairro,
      String? cidade,
      String? estado,
      //dados cobraça
      String? nome_iugu,
      String? telefone_cobranca,
      String? email_cobranca,
      String? cep_cobranca,
      String? endereco_cobranca,
      String? numero_cobranca,
      String? complemento_cobranca,
      String? bairro_cobranca,
      String? cidade_cobranca,
      String? estado_cobranca,
      //dados app
      String? razao_social_pf,
      String? razao_social,
      String? nome_fantasia,
      String? telefone1,
      String? telefone2,
      //adicionais

      String? responsavel2,
      String? email2,
      String? responsavel3,
      String? email3,
      String? responsavel4,
      String? email4,
      String? responsavel5,
      String? email5,

      //senhas
      String? novaSenha}) {
    return UserModel(
      responsavel: responsavel ?? this.responsavel,
      email_principal: email_principal ?? this.email_principal,
      cep: cep ?? this.cep,
      endereco: endereco ?? this.endereco,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      //dados cobraça
      nome_iugu: nome_iugu ?? this.nome_iugu,
      telefone_cobranca: telefone_cobranca ?? this.telefone_cobranca,
      email_cobranca: email_cobranca ?? this.email_cobranca,
      cep_cobranca: cep_cobranca ?? this.cep_cobranca,
      endereco_cobranca: endereco_cobranca ?? this.endereco_cobranca,
      numero_cobranca: numero_cobranca ?? this.numero_cobranca,
      complemento_cobranca: complemento_cobranca ?? this.complemento_cobranca,
      bairro_cobranca: bairro_cobranca ?? this.bairro_cobranca,
      cidade_cobranca: cidade_cobranca ?? this.cidade_cobranca,
      estado_cobranca: estado_cobranca ?? this.estado_cobranca,
      //dados app
      razao_social_pf: razao_social_pf ?? this.razao_social_pf,
      razao_social: razao_social ?? this.razao_social,
      nome_fantasia: nome_fantasia ?? this.nome_fantasia,
      telefone1: telefone1 ?? this.telefone1,
      telefone2: telefone2 ?? this.telefone2,
      //adicionais

      responsavel2: responsavel2 ?? this.responsavel2,
      email2: email2 ?? this.email2,
      responsavel3: responsavel3 ?? this.responsavel3,
      email3: email3 ?? this.email3,
      responsavel4: responsavel4 ?? this.responsavel4,
      email4: email4 ?? this.email4,
      responsavel5: responsavel5 ?? this.responsavel5,
      email5: email5 ?? this.email5,

      //senha
      novaSenha: novaSenha ?? this.novaSenha,
    );
  }
}
