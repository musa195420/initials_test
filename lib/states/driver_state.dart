class DriverState {
  final bool isLoading;
  final String? cnicUrl;
  final String? licenseUrl;

  const DriverState({
    this.isLoading = false,
    this.cnicUrl,
    this.licenseUrl,
  });

  DriverState copyWith({
    bool? isLoading,
    String? cnicUrl,
    String? licenseUrl,
  }) {
    return DriverState(
      isLoading: isLoading ?? this.isLoading,
      cnicUrl: cnicUrl ?? this.cnicUrl,
      licenseUrl: licenseUrl ?? this.licenseUrl,
    );
  }
}
