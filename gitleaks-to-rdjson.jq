# Convert gitleaks JSON output to Reviewdog Diagnostic Format (rdjson)
# https://github.com/reviewdog/reviewdog/blob/f577bd4b56e5973796eb375b4205e89bce214bd9/proto/rdf/reviewdog.proto
{
  source: {
    name: "gitleaks",
    url: "https://github.com/gitleaks/gitleaks"
  },
  diagnostics: . | map({
    message: .Description,
    code: {
      value: .RuleID
    } ,
    location: {
      path: .File,
      range: {
        start: {
          line: .StartLine,
          column: .StartColumn
        },
        end: {
          line: .EndLine,
          column: .EndColumn
        }
      }
    }
  })
}