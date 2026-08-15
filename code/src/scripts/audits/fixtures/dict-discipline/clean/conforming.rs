//! Known-negative fixture — this file MUST produce zero findings.

use std::collections::HashMap;

/// A newtype: an OrderId cannot be passed where a UserId is wanted.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct OrderId(pub String);

/// A state machine as an enum with data per variant — only legal states are representable.
#[derive(Debug, Clone)]
pub enum Order {
    Draft { id: OrderId },
    Placed { id: OrderId, total_pence: u32 },
}

/// A true index: the key is the lookup, and the value is a domain type.
pub type OrderIndex = HashMap<OrderId, Order>;

pub fn total_pence(order: &Order) -> Option<u32> {
    match order {
        Order::Draft { .. } => None,
        Order::Placed { total_pence, .. } => Some(*total_pence),
    }
}
