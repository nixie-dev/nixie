from types import SimpleNamespace
from behave import fixture, use_fixture

def before_all(context):
    ''' Populate the context with NixOS test objects
    '''
    context.nixos = SimpleNamespace(context.config.userdata)
