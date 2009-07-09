use inc::Module::Install;

perl_version '5.008';
all_from 'lib/MojoX/Session/Store/File.pm';

requires 'Mojo';
requires 'File::Slurp';
requires 'File::Spec';
requires 'Storable';

test_requires 'Test::More';

WriteAll;
