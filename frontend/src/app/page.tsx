export default async function Home() {
// Fetch from Tier 2, forcing it to skip caching so we see live data
      const backendUrl = process.env.BACKEND_URL || 'http://localhost:8080';
      const res = await fetch(`${backendUrl}/api/status`, { cache: 'no-store' });
      const data = await res.json();
// Fetch the users array from Spring Boot
  const usersRes = await fetch(`${backendUrl}/api/users`, { cache: 'no-store' });
  const users = await usersRes.json();
return (
  <>
    <h1 className="text-3xl font-bold mb-8">
      Live Cloud Data Test
    </h1>

    <main className="flex min-h-screen items-center justify-center bg-black">
      <div className="overflow-x-auto shadow-lg rounded-lg border border-gray-200">
        <table className="min-w-full bg-white">
          <thead className="bg-gray-800 text-white">
            <tr>
              <th className="px-6 py-3 text-left text-sm font-semibold">ID</th>
              <th className="px-6 py-3 text-left text-sm font-semibold">Name</th>
              <th className="px-6 py-3 text-left text-sm font-semibold">Email</th>
              <th className="px-6 py-3 text-left text-sm font-semibold">Role</th>
            </tr>
          </thead>

          <tbody className="divide-y divide-gray-200">
            {users.map((user: any) => (
              <tr key={user.id} className="hover:bg-gray-50">
                <td className="px-6 py-4 text-sm text-gray-900">{user.id}</td>
                <td className="px-6 py-4 text-sm text-gray-900 font-medium">
                  {user.name}
                </td>
                <td className="px-6 py-4 text-sm text-gray-500">
                  {user.email}
                </td>
                <td className="px-6 py-4 text-sm text-blue-600 font-medium">
                  {user.role}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </main>
  </>
);
}
