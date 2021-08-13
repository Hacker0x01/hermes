# include "ruby/ruby.h"
# include <stdlib.h>
# include <stdio.h>
# include "hermes.h"

// static VALUE tracing = Qfalse;
static VALUE tracepoints = Qnil;
static VALUE buffer = Qnil;

static VALUE
Buffer(VALUE self) {
  UNUSED(self);

  return buffer;
}

static VALUE
Add_to_buffer(VALUE self, VALUE value)
{
  UNUSED(self);

  if (TYPE(value) != T_STRING)
    rb_raise(rb_eTypeError, "value of a buffer entry must be String");

  rb_hash_aset(buffer, rb_str_dup(value), INT2FIX(0));
  return value;
};

/* TODO: is this the main callback func for tracepoint ? */
static void
call_event(VALUE trace_point, void *data) {
  rb_trace_arg_t *trace_arg;
  trace_arg = rb_tracearg_from_tracepoint(trace_point);

  VALUE rb_path = rb_tracearg_path(trace_arg);

  Add_to_buffer(Qnil, rb_path);
};

/* Setup TracePoint functionality */
/* taken from Byebug.c */
static void
register_tracepoints(VALUE self) {
  int i;
  VALUE traces = tracepoints;

  UNUSED(self);

  if (NIL_P(traces))
  {
    int call_msk = RUBY_EVENT_CALL;

    VALUE tpCall = rb_tracepoint_new(Qnil, call_msk, call_event, 0);

    traces = rb_ary_new();
    rb_ary_push(traces, tpCall);

    tracepoints = traces;
  }

  for (i = 0; i < RARRAY_LENINT(traces); i++)
    rb_tracepoint_enable(rb_ary_entry(traces, i));
}

/* Clear tracepoints */
/* taken from Byebug.c */
static void
clear_tracepoints(VALUE self) {
  int i;

  UNUSED(self);

  for (i = RARRAY_LENINT(tracepoints) - 1; i >= 0; i--)
    rb_tracepoint_disable(rb_ary_entry(tracepoints, i));
}

/* NOTE: start tracing */
static VALUE
Start(VALUE self) {
  buffer = rb_hash_new();
  register_tracepoints(self);

  return Qtrue;
}

static VALUE
Stop(VALUE self) {
  UNUSED(self);

  clear_tracepoints(self);

  tracepoints = Qnil;
  return Qtrue;
}


// NOTE: Map functions to ruby module
void Init_hermes(void) {
  VALUE Hermes = rb_define_module("Hermes");
  VALUE Native = rb_define_class_under(Hermes, "Native", rb_cObject);

  rb_define_singleton_method(Native, "buffer", Buffer, 0);
  rb_define_singleton_method(Native, "start", Start, 0);
  rb_define_singleton_method(Native, "stop", Stop, 0);
};
