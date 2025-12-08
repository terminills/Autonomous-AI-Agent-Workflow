# Autonomous Agent Integration Examples

This document provides practical examples of using the new autonomous agent features in your development workflow.

## Multi-Agent Collaboration

### Basic Setup

```python
from autonomous_build_agent import AutonomousExplorer, SMC_Coordinator

# Initialize your agents
explorer = AutonomousExplorer(llm_backend=my_llm, verbose=True)
smc = SMC_Coordinator(llm_backend=my_llm, verbose=True)

# Register SMC for collaboration
explorer.register_collaborating_agent(
    'SMC_Coordinator',
    smc,
    capabilities=['error_triage', 'state_routing', 'fix_coordination']
)
```

### Consulting Agents During Build Errors

```python
# When you encounter build errors
build_errors = ['undefined reference to symbol X', 'missing header file']

# Consult SMC for expert triage
query = {
    'question': 'How should I approach these build errors?',
    'context': {
        'phase': 'BUILD',
        'iteration': 3,
        'previous_attempts': ['clean build', 'dependency check']
    },
    'errors': build_errors
}

response = explorer.consult_agent('SMC_Coordinator', query)
print(f"SMC suggests: {response.get('action')}")
```

### Collaborative Decision Making

```python
# Make a decision with input from all registered agents
context = {
    'current_phase': 'BUILD_ERROR_ANALYSIS',
    'obstacles': 'multiple linking errors',
    'available_information': {
        'error_count': 15,
        'iteration': 4,
        'stuck': True
    }
}

# Explorer will consult all registered agents and synthesize their input
decision = explorer.collaborative_decision(context)

print(f"Collaborative decision: {decision['action']}")
print(f"Based on input from: {', '.join(decision['collaboration']['agents_consulted'])}")
print(f"Synthesis: {decision['collaboration']['synthesis']}")
```

## Curiosity-Driven Exploration

### Identifying Interesting Patterns

```python
# After several build iterations, see what the agent finds interesting
curious_patterns = explorer.identify_curious_patterns()

print(f"Agent identified {len(curious_patterns)} interesting patterns")
for pattern_info in curious_patterns[:3]:
    print(f"\nCuriosity Score: {pattern_info['curiosity_score']}")
    print(f"Why interesting: {', '.join(pattern_info['reasons'])}")
    print(f"Pattern: {pattern_info['pattern']['approach'][:60]}...")
```

### Exploring a Specific Pattern

```python
# Deep dive into why a particular approach worked
if curious_patterns:
    most_curious = curious_patterns[0]
    exploration = explorer.explore_curious_pattern(most_curious['pattern'])
    
    print(f"Insights gained: {exploration['insights']}")
    print("This helps generalize the approach for future use")
```

### Proactive Learning During Downtime

```python
# When the agent has downtime, let it learn proactively
# This could run between build iterations or after completing a task

summary = explorer.proactive_exploration_cycle()

print(f"Proactive exploration results:")
print(f"  - Patterns explored: {summary['patterns_explored']}")
print(f"  - Curious patterns found: {summary['curious_patterns_identified']}")
print(f"  - New insights: {len(summary['insights_gained'])}")

# The agent has now learned more about its successful patterns
# and can apply these insights to future problems
```

## Complete Integration Example

```python
#!/usr/bin/env python3
"""
Example: Autonomous agent with collaboration and curiosity-driven learning
"""

from autonomous_build_agent import (
    AutonomousExplorer, 
    SMC_Coordinator,
    AutonomousDevelopmentAgent
)

def autonomous_build_with_learning():
    """Run a build with full autonomous capabilities."""
    
    # Initialize main agent
    agent = AutonomousDevelopmentAgent(
        llm_type='llama2',
        verbose=True
    )
    
    # The agent automatically:
    # - Registers SMC and DualAgent for collaboration
    # - Uses long-term memory from previous runs
    # - Makes autonomous decisions during build
    
    # Run the build
    success = agent.run()
    
    if success:
        print("\n✅ Build completed successfully!")
    else:
        print("\n⚠️  Build had issues")
    
    # After build completes, agent automatically:
    # - Runs proactive exploration cycle
    # - Identifies curious patterns
    # - Learns from this session
    # - Saves insights to long-term memory
    
    # View what the agent learned
    stats = agent.explorer.get_memory_stats()
    print(f"\n🧠 Agent Memory:")
    print(f"  Total decisions: {stats['total_decisions']}")
    print(f"  Success patterns: {stats['success_patterns']}")
    print(f"  Consultations: {len(agent.explorer.consultation_history)}")
    
    # Export full learning history for analysis
    export_path = agent.explorer.export_learning_history()
    print(f"\n📤 Complete learning history: {export_path}")

if __name__ == "__main__":
    autonomous_build_with_learning()
```

## Advanced: Custom Curiosity Scoring

You can extend the curiosity scoring system to identify patterns relevant to your domain:

```python
class CustomExplorer(AutonomousExplorer):
    def identify_curious_patterns(self):
        """Override with custom curiosity criteria."""
        curious_patterns = super().identify_curious_patterns()
        
        # Add domain-specific curiosity factors
        for pattern_info in curious_patterns:
            pattern = pattern_info['pattern']
            
            # Boost score for patterns involving specific technologies
            if 'vulkan' in pattern['approach'].lower():
                pattern_info['curiosity_score'] += 15
                pattern_info['reasons'].append("Involves cutting-edge graphics")
            
            if 'optimization' in pattern['approach'].lower():
                pattern_info['curiosity_score'] += 10
                pattern_info['reasons'].append("Performance-related")
        
        # Re-sort by updated scores
        curious_patterns.sort(key=lambda x: x['curiosity_score'], reverse=True)
        return curious_patterns
```

## Benefits in Practice

### Before (Static Script):
```
Build fails → Try fix A → Fail → Try fix B → Fail → Give up
```

### After (Autonomous Agent with Collaboration & Curiosity):
```
Build fails → 
  Consult SMC for triage →
  Explorer decides on memory-informed strategy →
  If stuck, consult DualAgent for complex reasoning →
  Apply collaborative solution →
  Learn from outcome →
  Identify what made this interesting →
  Explore pattern to generalize →
  Save insights for future
```

The agent transforms from a linear script into an intelligent system that:
- **Learns** from every interaction
- **Collaborates** with specialized experts
- **Discovers** interesting patterns proactively
- **Improves** continuously over time

This is true autonomous behavior - similar to how GitHub Copilot learns and adapts, but running locally with full transparency into the agent's decision-making process.
