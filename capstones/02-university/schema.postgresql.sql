-- University starter schema / Početna šema univerzitetskog projekta.

CREATE SCHEMA IF NOT EXISTS university;

CREATE TABLE university.students (
  student_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  university_number text NOT NULL UNIQUE,
  full_name text NOT NULL,
  email text NOT NULL UNIQUE
);

CREATE TABLE university.terms (
  term_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  term_name text NOT NULL UNIQUE,
  enrollment_open_at timestamptz NOT NULL,
  enrollment_close_at timestamptz NOT NULL,
  CHECK (enrollment_close_at > enrollment_open_at)
);

CREATE TABLE university.courses (
  course_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  course_code text NOT NULL UNIQUE,
  title text NOT NULL,
  ects smallint NOT NULL CHECK (ects BETWEEN 1 AND 30)
);

CREATE TABLE university.course_prerequisites (
  course_id bigint NOT NULL REFERENCES university.courses(course_id) ON DELETE CASCADE,
  prerequisite_course_id bigint NOT NULL REFERENCES university.courses(course_id) ON DELETE RESTRICT,
  PRIMARY KEY (course_id, prerequisite_course_id),
  CHECK (course_id <> prerequisite_course_id)
);

CREATE TABLE university.sections (
  section_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  course_id bigint NOT NULL REFERENCES university.courses(course_id),
  term_id bigint NOT NULL REFERENCES university.terms(term_id),
  capacity integer NOT NULL CHECK (capacity > 0),
  UNIQUE (course_id, term_id)
);

CREATE TABLE university.enrollments (
  enrollment_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_id bigint NOT NULL REFERENCES university.students(student_id),
  section_id bigint NOT NULL REFERENCES university.sections(section_id),
  status text NOT NULL CHECK (status IN ('enrolled', 'withdrawn', 'completed')),
  final_grade numeric(3,1) CHECK (final_grade BETWEEN 5.0 AND 10.0),
  enrolled_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (student_id, section_id)
);

CREATE INDEX sections_term_id_idx ON university.sections(term_id);
CREATE INDEX enrollments_student_id_idx ON university.enrollments(student_id);
CREATE INDEX enrollments_section_status_idx ON university.enrollments(section_id, status);
