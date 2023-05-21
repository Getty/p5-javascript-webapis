
requires 'Data::Printer', '0';
requires 'Term::ANSIColor', '0';
requires 'File::ShareDir::ProjectDistDir', '0';
requires 'Module::Runtime', '0';
requires 'Moo', '0';
requires 'Path::Tiny', '0';

on test => sub {
  requires 'Test2::Suite', '0.000155';
  recommends 'JavaScript::V8', '0.11';
};
