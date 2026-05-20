export default async function Home() {
// Fetch from Tier 2, forcing it to skip caching so we see live data
      const backendUrl = process.env.BACKEND_URL || 'http://localhost:8080';
      const res = await fetch(`${backendUrl}/api/status`, { cache: 'no-store' });
      const data = await res.json();
  return (
 <main className="flex min-h-screen items-center justify-center bg-black">
      <div className="rounded-2xl bg-white px-10 py-6 shadow-xl">
        <h1 className="text-3xl font-bold text-center text-black">
          {data.status}
        </h1>
      </div>
    </main>
  );
}
