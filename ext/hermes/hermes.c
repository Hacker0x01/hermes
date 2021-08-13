# include "ruby/ruby.h"
# include <stdlib.h>
# include <stdio.h>
# include "hermes.h"

static VALUE hello_world(VALUE self) {
  library_hello_world();

  return self;
}

void library_hello_world() {
  printf("hello world from C\n");
};

void Init_hermes(void) {
  VALUE Hermes = rb_define_module("Hermes");
  VALUE NativeHelpers = rb_define_class_under(Hermes, "NativeHelpers", rb_cObject);

  rb_define_singleton_method(NativeHelpers, "hello_world", hello_world, 0);
};
