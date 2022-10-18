# globals <- checkhelper::get_no_visible()
# checkhelper::print_globals(globals)

globalVariables(unique(c(
  # codex_icd10:
  "V1",
  "V2",

  # codex_mue:
  "quarter_begin_date",
  "mue_value",
  "hcpcscpt_code",

  # codex_ptp:
  'quarter_begin_date',
  'effective_date',
  'deletion_date',
  'modifier_indicator',
  'column_1',
  'column_2',
  'ptp_edit_rationale'

)))
