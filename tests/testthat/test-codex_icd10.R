httptest2::without_internet({
  test_that("`codex_icd10()` returns correct request URL", {

    httptest2::expect_GET(codex_icd10(code = "A15"),
      'https://clinicaltables.nlm.nih.gov/api/icd10cm/v3/search?terms=A15&maxList=10&sf=code%2Cname')

    httptest2::expect_GET(codex_icd10(code = "z", field = "code"),
      'https://clinicaltables.nlm.nih.gov/api/icd10cm/v3/search?terms=z&maxList=10&sf=code')
  })
})
