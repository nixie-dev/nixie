'''This module is responsible for setting up the 'nixie-env.nix' file
created by applying a Nixie template
'''

class NixieFlake:
    '''An object representing the expressions Nixie looks for when editing
    a template flake.nix
    '''
    project_name: str
    project_version: str

    env_namespaces: list[str]

    fullfile: str
    def __init__(self, file: StringIO):
        '''Populate object from parsed flake.nix'''
        fullfile = file.read()

    def build(self, dest: StringIO):
        pass

class NixieEnv:
    '''An object representing the generated nixie-env.nix file with scanned
    dependencies
    '''
    namespaces: dict[str,list[str]]

    def __init__(self, origin: list[str] | Path):
        '''Populate object with a default namespace set or an existing file
        '''
        if type(origin) is list:
            self.namespaces = { n: [] for n in origin }
        else:
            pass

    def addDependency(self, fp: str):
        pass

    def build(self, dest: StringIO):
        '''Build a valid Nix source file containing the specified dependencies
        '''
