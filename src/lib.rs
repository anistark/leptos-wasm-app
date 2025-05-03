use leptos::*;

#[component]
pub fn App() -> impl IntoView {
    view! {
        <div class="app">
            <h1>"Leptos WASM App"</h1>
            <Counter />
            <TodoApp />
        </div>
    }
}

#[component]
fn Counter() -> impl IntoView {
    let (count, set_count) = create_signal(0);
    let increment = move |_| set_count.update(|count| *count += 1);
    let decrement = move |_| set_count.update(|count| *count -= 1);
    let reset = move |_| set_count.set(0);
    
    view! {
        <div>
            <h2>"Counter Example"</h2>
            <div class="counter">
                <button on:click=decrement>"-1"</button>
                <span class="value">{count}</span>
                <button on:click=increment>"+1"</button>
                <button on:click=reset>"Reset"</button>
            </div>
        </div>
    }
}

#[derive(Debug, Clone)]
struct Todo {
    id: u32,
    text: String,
    completed: bool,
}

#[component]
fn TodoApp() -> impl IntoView {
    let (todos, set_todos) = create_signal(Vec::<Todo>::new());
    
    let (new_todo_text, set_new_todo_text) = create_signal(String::new());
    
    let next_id = create_rw_signal(1);
    
    let add_todo = move |_: web_sys::MouseEvent| {
        let text = new_todo_text.get();
        if !text.is_empty() {
            set_todos.update(|todos| {
                todos.push(Todo {
                    id: next_id.get(),
                    text,
                    completed: false,
                });
            });
            next_id.update(|id| *id += 1);
            set_new_todo_text.set(String::new());
        }
    };
    
    let toggle_todo = move |id: u32| {
        set_todos.update(|todos| {
            if let Some(todo) = todos.iter_mut().find(|t| t.id == id) {
                todo.completed = !todo.completed;
            }
        });
    };
    
    let remove_todo = move |id: u32| {
        set_todos.update(|todos| {
            todos.retain(|t| t.id != id);
        });
    };
    
    view! {
        <div class="todo-app">
            <h2>"Todo List Example"</h2>
            <div class="todo-input">
                <input 
                    type="text"
                    placeholder="Add a new todo"
                    prop:value=new_todo_text
                    on:input=move |ev| {
                        set_new_todo_text.set(event_target_value(&ev));
                    }
                    on:keyup=move |ev| {
                        if ev.key() == "Enter" {
                            let text = new_todo_text.get();
                            if !text.is_empty() {
                                set_todos.update(|todos| {
                                    todos.push(Todo {
                                        id: next_id.get(),
                                        text,
                                        completed: false,
                                    });
                                });
                                next_id.update(|id| *id += 1);
                                set_new_todo_text.set(String::new());
                            }
                        }
                    }
                />
                <button on:click=add_todo>"Add"</button>
            </div>
            
            <ul class="todo-list">
                <For
                    each=move || todos.get()
                    key=|todo| todo.id
                    children=move |todo: Todo| {
                        let id = todo.id;
                        let completed = todo.completed;
                        
                        view! {
                            <li class:todo-item=true class:completed=completed>
                                <input 
                                    type="checkbox"
                                    prop:checked=completed
                                    on:change=move |_| toggle_todo(id)
                                />
                                <span>{todo.text}</span>
                                <button on:click=move |_| remove_todo(id)>"Delete"</button>
                            </li>
                        }
                    }
                />
            </ul>
        </div>
    }
}
