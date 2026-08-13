class ChargeOperator {
  final String id;
  final String name;
  final String logoLetter;
  final bool hasAppIntegration;

  const ChargeOperator({
    required this.id,
    required this.name,
    required this.logoLetter,
    this.hasAppIntegration = false,
  });
}
