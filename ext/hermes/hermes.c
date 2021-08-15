# include "ruby/ruby.h"
# include <stdlib.h>
# include <stdio.h>
# include "hermes.h"

static VALUE tracepoints = Qnil;
static VALUE buffer = Qnil;
static char *rails_root = NULL;
static int is_started = 0;

static VALUE
Buffer(VALUE self) {
  UNUSED(self);

  return buffer;
}

static int
starts_with(const char *pre, const char *str) {
  return strncmp(pre, str, strlen(pre)) == 0;
}

static void
add_to_buffer(const char *path) {
  rb_hash_aset(buffer, rb_str_new2(path), INT2FIX(0));
};

/* TODO: is this the main callback func for tracepoint ? */
static void
call_event(VALUE trace_point, void *data) {
  rb_trace_arg_t *trace_arg;
  trace_arg = rb_tracearg_from_tracepoint(trace_point);

  VALUE rb_path = rb_tracearg_path(trace_arg);
  const char *path = NIL_P(rb_path) ? "" : RSTRING_PTR(rb_path);

  if (!starts_with(rails_root, path))
    return;

  add_to_buffer(path);
};

/* Setup TracePoint functionality */
/* taken from Byebug.c */
static void
register_tracepoints(VALUE self) {
  int i;
  VALUE traces = tracepoints;

  UNUSED(self);

  if (NIL_P(traces)) {
    int call_msk = RUBY_EVENT_CALL;

    VALUE tpCall = rb_tracepoint_new(Qnil, call_msk, call_event, 0);

    traces = rb_ary_new();
    rb_ary_push(traces, tpCall);

    tracepoints = traces;
  }

  for (i = 0; i < RARRAY_LENINT(traces); i++)
    rb_tracepoint_enable(rb_ary_entry(traces, i));
}

/* Disable tracepoints */
/* taken from Byebug.c */
static void
disable_tracepoints(VALUE self) {
  int i;

  UNUSED(self);

  for (i = RARRAY_LENINT(tracepoints) - 1; i >= 0; i--)
    rb_tracepoint_disable(rb_ary_entry(tracepoints, i));
}

static VALUE
Started(VALUE self) {
  UNUSED(self);

  return is_started ? Qtrue : Qfalse;
}

/* NOTE: start tracing */
static VALUE
Start(VALUE self) {
  if (is_started)
    return Qfalse;

  buffer = rb_hash_new();

  register_tracepoints(self);
  is_started = 1;

  return Qtrue;
}

static VALUE
Stop(VALUE self) {
  if (!is_started)
    return Qfalse;

  disable_tracepoints(self);
  is_started = 0;

  return Qtrue;
}

static VALUE
SetRailsRoot(VALUE self, VALUE value) {
  rails_root = RSTRING_PTR(value);

  return Qtrue;
}


// NOTE: Map functions to ruby module
void Init_hermes(void) {
  VALUE HermesNative = rb_define_module("HermesNative");

  rb_define_module_function(HermesNative, "buffer", Buffer, 0);
  rb_define_module_function(HermesNative, "set_rails_root", SetRailsRoot, 1);
  rb_define_module_function(HermesNative, "start", Start, 0);
  rb_define_module_function(HermesNative, "started", Started, 0);
  rb_define_module_function(HermesNative, "stop", Stop, 0);

  rb_global_variable(&tracepoints);
  rb_global_variable(&buffer);
};
