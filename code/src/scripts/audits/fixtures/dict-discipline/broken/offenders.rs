//! Known-positive fixture — every line here MUST be reported. Never "fix" this file.

use std::collections::HashMap;

pub fn decode(raw: &str) -> HashMap<String, serde_json::Value> { // R1 + R2
    let _ = raw;
    HashMap::new()
}

pub struct Envelope {
    pub body: serde_json::Value, // R2
}
