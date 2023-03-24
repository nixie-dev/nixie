'''This module is responsible for fetching the predicates derivation, as well
as this of the selected template.
'''

from ..                     import nix

EXPR_NIXIE_TEMPLATES = "github:nixie-dev/templates"

def get_preds():
    return flake_build(EXPR_NIXIE_TEMPLATES + "#predicates")
