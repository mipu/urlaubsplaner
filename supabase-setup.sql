-- Supabase Setup für Urlaubsplaner

-- 1. Tabelle für Konfiguration
CREATE TABLE IF NOT EXISTS config (
  id INT PRIMARY KEY DEFAULT 1,
  firma_name VARCHAR(255) DEFAULT 'Beispiel GmbH',
  year INT DEFAULT 2027,
  logo_image TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 2. Tabelle für Mitarbeiter
CREATE TABLE IF NOT EXISTS employees (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  department VARCHAR(255) DEFAULT 'Allgemein',
  vacation_days INT DEFAULT 20,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 3. Tabelle für Urlaubseinträge
CREATE TABLE IF NOT EXISTS vacation_entries (
  id BIGSERIAL PRIMARY KEY,
  employee_id BIGINT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  entry_date DATE NOT NULL,
  status VARCHAR(50) DEFAULT 'normal', -- normal, vacation, pending, sick, holiday
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(employee_id, entry_date)
);

-- 4. Initiale Konfiguration
INSERT INTO config (firma_name, year) VALUES ('Beispiel GmbH', 2027)
ON CONFLICT (id) DO NOTHING;

-- 5. Standard-Mitarbeiter
INSERT INTO employees (name, department, vacation_days) VALUES
  ('Anna Schmidt', 'Leitung', 25),
  ('Max Mustermann', 'Vertrieb', 20),
  ('Lisa Müller', 'Entwicklung', 20),
  ('Peter Weber', 'HR', 22),
  ('Sandra Krämer', 'Logistik', 20),
  ('Thomas Bauer', 'Technik', 20),
  ('Petra Fischer', 'Verwaltung', 20),
  ('Klaus Meyer', 'Lager', 20),
  ('Sabine Hoffmann', 'Kundendienst', 20),
  ('Frank Schulz', 'Vertrieb', 20),
  ('Martina Winter', 'Qualität', 20),
  ('Jürgen König', 'Produktion', 20),
  ('Christine Groß', 'Entwicklung', 20),
  ('Herbert Lange', 'Lager', 20),
  ('Katrin Wolf', 'Vertrieb', 20),
  ('Dieter Schäfer', 'Technik', 20),
  ('Renate Becker', 'Verwaltung', 20),
  ('Werner Richter', 'Logistik', 20),
  ('Silke Mayer', 'Kundendienst', 20),
  ('Helmut Schröder', 'Produktion', 20),
  ('Angelika Hartmann', 'Qualität', 20),
  ('Reinhard Sommer', 'Lager', 20),
  ('Gisela Pfeiffer', 'Entwicklung', 20),
  ('Bernd Adler', 'Vertrieb', 20),
  ('Monika Kaiser', 'Verwaltung', 20)
ON CONFLICT DO NOTHING;

-- 6. Indexes für Performance
CREATE INDEX IF NOT EXISTS idx_vacation_employee_id ON vacation_entries(employee_id);
CREATE INDEX IF NOT EXISTS idx_vacation_entry_date ON vacation_entries(entry_date);

-- 7. Realtime aktivieren
ALTER PUBLICATION supabase_realtime ADD TABLE config;
ALTER PUBLICATION supabase_realtime ADD TABLE employees;
ALTER PUBLICATION supabase_realtime ADD TABLE vacation_entries;
