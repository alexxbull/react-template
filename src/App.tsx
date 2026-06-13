import { useState } from "react";

const App = () => {
  const [count, setCount] = useState(0);
  const staticStyle = { color: "purple", fontWeight: "bold" };

  return (
    <div style={{ alignContent: "center", textAlign: "center" }}>
      <button onClick={() => setCount((c) => c + 1)}>Count: {count}</button>
      <p style={staticStyle}>
        If react compiler is working, I am memoized. Check React Devtools to confirm!
      </p>
    </div>
  );
};

export default App;
